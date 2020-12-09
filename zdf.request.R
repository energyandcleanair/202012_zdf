require(rcrea)
require(creadeweather)
require(dplyr)

# Cities of interest
cities <- c("Berlin", "Essen", "Hamburg", "Munich", "Frankfurt", "Dusseldorf", "Koeln", "Dortmund", "Leipzig", "Stuttgart")

# Create result directories
dir_results <- file.path("results")
dir.create(dir_results, showWarnings = F, recursive = T)
dir.create(file.path(dir_results,"stations"), showWarnings = F, recursive = T)
dir.create(file.path(dir_results,"deweathered"), showWarnings = F, recursive = T)
dir.create(file.path(dir_results,"observations"), showWarnings = F, recursive = T)


# Stations ----------------------------------------------------------------

stations <- rcrea::stations(city=cities, source="eea", with_metadata = T)
stations %>%
  write.csv(file=file.path(dir_results, "stations", "stations.csv"), row.names = F)


# Deweather data --------------------------------------------------------
# Can only be run on server
if(F){
  creadeweather::deweather(city=cities, source="eea", poll=rcrea::NO2, add_pbl=T, upload_results=T)
}


# Get measurements --------------------------------------------------------
m <- rcrea::measurements(poll=rcrea::NO2, date_from="2015-12-01", source="eea", city=cities, with_metadata = T, deweathered = NULL)


# Export data -------------------------------------------------------------
m %>% filter(process_id=="city_day_mad") %>%
  write.csv(file=file.path(dir_results, "obervations", "obervations.csv"), row.names = F)
m %>% filter(process_id=="anomaly_offsetted_gbm_lag1_city_mad_pbl") %>%
  write.csv(file=file.path(dir_results, "deweathered", "deweathered.csv"), row.names = F)
m %>% filter(process_id=="anomaly_gbm_lag1_city_mad_pbl") %>%
  write.csv(file=file.path(dir_results, "deweathered",, "deweathered_anomaly.csv"), row.names = F)
m %>% filter(process_id=="anomaly_offsetted_gbm_lag1_city_mad_pbl") %>%
  write.csv(file=file.path(dir_results, "deweathered", "deweathered_anomaly_offsetted.csv"), row.names = F)


# Plot --------------------------------------------------------------------
rcrea::plot_recents(meas_raw=m %>% filter(process_id=="city_day_mad"),
                    running_days = 30,
                    color_by = "region_id",
                    subplot_by = "region_id",
                    subfile_by = "poll",
                    folder = "202011_zdf/results/observations",
                    size="l",
                    add_lockdown = T
)

rcrea::plot_recents(meas_raw=m %>% filter(process_id=="city_day_mad"),
                    running_days = 30,
                    color_by = "region_id",
                    subfile_by = "country",
                    folder = "202011_zdf/results/observations",
                    size="l",
                    add_lockdown = T
                    )

rcrea::plot_recents(meas_raw=m %>% filter(process_id=="anomaly_offsetted_gbm_lag1_city_mad_pbl"),
                    running_days = 30,
                    color_by = "region_id",
                    subfile_by = "country",
                    folder = "202011_zdf/results/deweathered",
                    size="l",
                    add_lockdown = T
)

rcrea::plot_recents(meas_raw=m %>% filter(process_id=="anomaly_vs_counterfactual_gbm_lag1_city_mad_pbl"),
                    running_days = 30,
                    color_by = "region_id",
                    subfile_by = "country",
                    folder = "202011_zdf/results/deweathered",
                    size="l",
                    add_lockdown = T,
                    percent = T,
                    file_suffix = 'percent'
)

rcrea::plot_recents(meas_raw=m %>% filter(process_id=="anomaly_offsetted_gbm_lag1_city_mad_pbl"),
                    running_days = 30,
                    color_by = "region_id",
                    subplot_by = "region_id",
                    subfile_by = "poll",
                    folder = "202011_zdf/results/deweathered",
                    size="l",
                    add_lockdown = T
)

rcrea::plot_recents(meas_raw=m %>% filter(process_id=="anomaly_vs_counterfactual_gbm_lag1_city_mad_pbl"),
                    running_days = 30,
                    color_by = "region_id",
                    subplot_by = "region_id",
                    subfile_by = "poll",
                    folder = "202011_zdf/results/deweathered",
                    size="l",
                    title = "NO2 weather-corrected anomalies",
                    add_lockdown = T,
                    percent = T,
                    file_suffix = 'percent'
)
