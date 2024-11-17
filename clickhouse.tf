module "clickhouse" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-mdb-clickhouse.git?ref=v1.0.0"

  network_id = module.network.vpc_id

  users = [
    {
      name     = "sentry"
      password = "password1"
    }
  ]

  databases = [
    {
      name = "sentry"
    }
  ]

  hosts = [
    {
      type             = "CLICKHOUSE"
      zone             = "ru-central1-a"
      subnet_id        = module.network.private_subnets_ids[0]
      assign_public_ip = true
    }
  ]

  # Optional variables
  name                          = "clickhouse-sentry"
  clickhouse_disk_size          = 10
  clickhouse_disk_type_id       = "network-ssd"
  clickhouse_resource_preset_id = "s3-c2-m8"
  environment                   = "PRODUCTION"
  clickhouse_version            = "24.3"
  description                   = "ClickHouse sentry description"
  folder_id                     = data.yandex_client_config.client.folder_id

  depends_on = [module.iam_accounts, module.network]
}