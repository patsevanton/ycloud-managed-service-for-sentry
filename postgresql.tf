module "postgresql_cluster" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-mdb-postgresql.git?ref=v1.0.0"

  name        = "my-postgresql-cluster"
  environment = "PRODUCTION"
  network_id  = module.network.vpc_id
  description = "My PostgreSQL cluster description"
  folder_id   = data.yandex_client_config.client.folder_id

  postgresql_version = "15"

  resource_preset_id  = "s2.micro"
  disk_type_id        = "network-ssd"
  disk_size           = 70
  deletion_protection = false

  disk_size_autoscaling = {
    disk_size_limit           = 200
    planned_usage_threshold   = 70
    emergency_usage_threshold = 90
  }

  hosts = [
    {
      zone             = "ru-central1-a"
      subnet_id        = module.network.private_subnets_ids[0]
      assign_public_ip = true
      name             = "host-a"
      priority         = 1
    }
  ]

  postgresql_config = {
    max_connections                = 395
    enable_parallel_hash           = true
    autovacuum_vacuum_scale_factor = 0.34
    default_transaction_isolation  = "TRANSACTION_ISOLATION_READ_COMMITTED"
    shared_preload_libraries       = "SHARED_PRELOAD_LIBRARIES_AUTO_EXPLAIN,SHARED_PRELOAD_LIBRARIES_PG_HINT_PLAN"
  }

  maintenance_window = {
    type = "WEEKLY"
    day  = "SAT"
    hour = 12
  }

  access = {
    data_lens     = true
    web_sql       = true
    serverless    = false
    data_transfer = true
  }
  performance_diagnostics = {
    enabled                      = true
    sessions_sampling_interval   = 60
    statements_sampling_interval = 60
  }
  backup_window_start = {
    hours   = 2
    minutes = 0
  }
  pooler_config = {
    pool_discard = false
    pooling_mode = "SESSION"
  }

  database_name                = "sentry"
  database_owner               = "sentry"
  lc_collate                   = "en_US.UTF-8"
  lc_type                      = "en_US.UTF-8"
  template_db                  = null
  database_deletion_protection = false

  extensions = [
    {
      name    = "citext"
    }
  ]

  user_name                = "sentry"
  user_password            = "my_password"
  user_login               = true
  user_conn_limit          = 50
  user_settings            = {}
  user_deletion_protection = false

  autofailover = true
  backup_retain_period_days = 14

  depends_on = [module.network]
}
