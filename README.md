# cloud-native-notes
学习 云原生 shell python go devops sre过程中的记录，AI辅助学习的确节省动则上万的培训费用，虽然AI能力不断增强，但在实践过程中发现越是深入的技术，AI反而不擅长，给的答案要么东拼西凑，要么不符合特定版本。举个例子，自建k8s云原生的高可用控制平面，都不推荐keepalived+haproxy，推荐kube-vip，但是如何部署呢？我用主流的AI包括chatgpt grok qwen Gemini，新建集群时他们给出各种方案均失败。正解乃是先用kubeadm正常建好，再部署kube-vip，再改证书。

看网上公开的大培训机构的视频+自学，需要强大的定力和信心，他们的视频被人放到网上一般就是版本老旧不适合生产环境了，话句话说学他们演示的版本基本上找不到活了，一路走来有收获也有痛苦。高中不努力，大学甚至毕业后就得格外努力。

k8s版本采用1.29.8，容器运行时containerd://1.7.22，OS 选择Rocky Linux 9.6 (Blue Onyx)，Ubuntu 22.04.5 LTS，放到2026年应该不算过时，我看阿里云的aes os版本更旧。服务器自购二手浪潮SA5212M5，服务器配置双路Intel Xeon Gold 6138，Intel P4510 1T NVMe，64GB，万幸内存涨价之前入手，固态盘全新，总价2000+元rmb。服务器OS Proxmox VE 8.4.13
