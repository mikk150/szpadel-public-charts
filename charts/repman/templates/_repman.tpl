
{{/* Make sure all variables are set properly */}}
{{- include "common.values.setup" . }}

{{- define "repman.repman.config.services" -}}
parameters:
  aws_s3_region: '%env(STORAGE_AWS_REGION)%'
  aws_s3_default_endpoint: 'https://s3.%aws_s3_region%.amazonaws.com'
services:
  Aws\S3\S3Client:
    lazy: true
    arguments:
    - version: 'latest'
      region: '%aws_s3_region%'
      endpoint: '%env(default:aws_s3_default_endpoint:STORAGE_AWS_ENDPOINT)%'
      use_path_style_endpoint: '%env(bool:STORAGE_AWS_PATH_STYLE_ENDPOINT)%'
      credentials:
        key: '%env(STORAGE_AWS_KEY)%'
        secret: '%env(STORAGE_AWS_SECRET)%'
{{- end -}}

{{- define "repman.repman.config.secrets" -}}
{{- $existingSecret := lookup "v1" "Secret" .Release.Namespace (include "common.names.fullname" .) | default dict -}}
{{- $secret := dig "data" "APP_SECRET" (randAlphaNum 32 | b64enc) $existingSecret }}
APP_SECRET: {{ $secret }}
{{- end -}}
