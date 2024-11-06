<template>
  <div class="remote-server-manager">
    <el-form :model="serverInfo" :rules="rules" ref="serverForm" label-width="120px">
      <el-form-item label="IP 地址" prop="ip">
        <el-input v-model="serverInfo.ip" placeholder="请输入服务器 IP 地址" />
      </el-form-item>

      <el-form-item label="端口" prop="port">
        <el-input v-model="serverInfo.port" placeholder="请输入端口号" />
      </el-form-item>

      <el-form-item label="用户名" prop="username">
        <el-input v-model="serverInfo.username" placeholder="请输入用户名" />
      </el-form-item>

      <el-form-item label="密码" prop="password">
        <el-input v-model="serverInfo.password" type="password" placeholder="请输入密码" />
      </el-form-item>

      <el-form-item label="SSH 密钥" prop="sshKey">
        <el-input v-model="serverInfo.sshKey" type="textarea" placeholder="或粘贴 SSH 私钥内容" />
      </el-form-item>

      <el-button type="primary" @click="connectToServer">连接服务器</el-button>
    </el-form>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'RemoteServerManager',
  data() {
    return {
      serverInfo: {
        ip: '',
        username: '',
        password: '',
        sshKey: '',
      },
      rules: {
        ip: [{ required: true, message: '请输入 IP 地址', trigger: 'blur' }],
        port: [{ required: true, message: '请输入端口号', trigger: 'blur' }],
        username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
        // 使用自定义校验规则，确保密码和 SSH 密钥至少填写一个
        password: [
          { validator: (rule, value, callback) => {
              if (!value && !this.serverInfo.sshKey) {
                callback(new Error('密码和 SSH 密钥至少填写一个'));
              } else {
                callback();
              }
            }, 
            trigger: 'blur'
          }
        ],
      },
    };
  },
  methods: {
    async connectToServer() {
      // 使用 validate 方法进行表单验证
      this.$refs.serverForm.validate(async (valid) => {
        if (!valid) {
          this.$message.error('请完整填写表单信息');
          return;
        }
        
        // 发起请求，连接服务器
        this.$message.success('正在连接到服务器...');
        try {
          const response = await axios.post('/api/remote/connect', this.serverInfo);
          if (response.data.success) {
            this.$message.success('连接成功！');
          } else {
            this.$message.error('连接失败，请检查服务器信息');
          }
        } catch (error) {
          this.$message.error('连接失败，服务器异常');
        }
      });
    },
  },
};
</script>

<style scoped>
/* 可以在这里添加页面的样式 */
</style>
