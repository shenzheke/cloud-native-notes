helm repo add gitlab https://charts.gitlab.io
helm repo update

kubectl create namespace gitlab-runner

helm upgrade --install gitlab-runner gitlab/gitlab-runner \
  -n gitlab-runner \
  --set gitlabUrl=http://10.0.0.200 \
  --set runnerRegistrationToken=xxxxxxxxxxxxxxx \
  --set runners.executor=kubernetes \
  --set rbac.create=false \
  --set serviceAccount.create=false \
  --set serviceAccount.name=gitlab-runner




