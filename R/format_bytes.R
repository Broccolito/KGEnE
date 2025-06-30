format_bytes = function(bytes){
  units = c("B", "KB", "MB", "GB", "TB")
  power = if (bytes > 0){
    floor(log(bytes, 1024))
  } else 0
  power = min(power, length(units) - 1)
  formatted = round(bytes / 1024^power, 2)
  paste(formatted, units[power + 1])
}