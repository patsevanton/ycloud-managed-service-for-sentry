module "kube" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-kubernetes.git?ref=v1.0.0"

  network_id = module.network.vpc_id

  name = "k8s-sentry"
  master_version = 1.27

  service_account_id      = module.iam_accounts.id
  node_service_account_id = module.iam_accounts.id

  master_locations = [
    {
      zone      = "ru-central1-a"
      subnet_id = module.network.private_subnets_ids[0]
    }
  ]

  node_groups = {
    "default" = {
      nat    = true
      cores  = 2
      memory = 8
      fixed_scale = {
        size = 3
      }
    }
  }

  depends_on = [module.iam_accounts]

}
