# Debugging

This file exists with the purpose of helping you debug your issues with `monitoringstack`. This is not a foolproof file, it may miss certain issues and steps.

## Issues

### High Command Timeout

Seagate drives currently have an issue with `smartmontools` and more specifically `drivedb`.  
If you see a number like: `4295032833`. Checkout the resources below to make yourself rest easy again.

Github Issues: [#885](https://github.com/AnalogJ/scrutiny/discussions/885) & [#871](https://github.com/AnalogJ/scrutiny/issues/871)
Articles: [Big scary Raw S.M.A.R.T. values aren’t always bad news!](https://www.disktuna.com/big-scary-raw-s-m-a-r-t-values-arent-always-bad-news/#21475164165)

## Helping others

If you have found more issues while following the steps and figured it out please create a pull request with your issue and it's debugging steps and resolution.
