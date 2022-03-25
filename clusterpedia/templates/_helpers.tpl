{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "clusterpedia.apiserver.fullname" -}}
{{- printf "%s-%s" .Release.Name "apiserver" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "clusterpedia.clustersynchroManager.fullname" -}}
{{- printf "%s-%s-%s" .Release.Name "clustersynchro" "manager" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper kong image name
*/}}
{{- define "clusterpedia.apiserver.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.apiServer.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper kong image name
*/}}
{{- define "clusterpedia.clustersynchroManager.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.clustersynchroManager.image "global" .Values.global) }}
{{- end -}}

{{- define "clusterpedia.internalstorage.fullname" -}}
{{- printf "%s-%s" .Release.Name "internalstorage" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "clusterpedia.apiserver.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.apiServer.image) "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "clusterpedia.clustersynchroManager.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.clustersynchroManager.image) "global" .Values.global) }}
{{- end -}}

{{- define "clusterpedia.storage.user" -}}
{{- if eq .Values.storageInstallMode "external" }}
     {{- .Values.external.user -}}
{{- else -}}
     {{- if and .Values.postgresql.enabled (eq .Values.database "postgresql") -}}
          {{- if not (empty .Values.global.postgresql.auth.username) -}}
               {{- .Values.global.postgresql.auth.username -}}
          {{- else -}}
               {{- "postgres" -}}
          {{- end -}}
               {{- else if and .Values.mysql.enabled (eq .Values.database "mysql") -}}
          {{- if not (empty .Values.mysql.auth.username) -}}
               {{- .Values.mysql.auth.username -}}
          {{- else -}}
               {{- "root" -}}
          {{- end -}}
     {{- end -}}
{{- end -}}
{{- end -}}

{{- define "clusterpedia.storage.password" -}}
{{- if eq .Values.storageInstallMode "external" }}
     {{- .Values.external.password -}}
{{- else -}}
     {{- if and .Values.postgresql.enabled (eq .Values.database "postgresql") }}
          {{- if not (empty .Values.global.postgresql.auth.username) -}}
               {{- .Values.global.postgresql.auth.password | b64enc -}}
          {{- else -}}
               {{- .Values.global.postgresql.auth.postgresPassword | b64enc -}}
          {{- end -}}
     {{- else if and .Values.mysql.enabled (eq .Values.database "mysql") -}}
          {{- if not (empty .Values.mysql.auth.username) -}}
               {{- .Values.mysql.auth.password  | b64enc -}}
          {{- else -}}
               {{- .Values.mysql.auth.rootPassword | b64enc -}}
          {{- end -}}
     {{- end -}}
{{- end -}}
{{- end -}}

{{/* use the default port */}}
{{- define "clusterpedia.storage.port" -}}
{{- if eq .Values.storageInstallMode "external" }}
     {{- .Values.external.port -}}
{{- else -}}
     {{- if and .Values.postgresql.enabled (eq .Values.database "postgresql") -}}
     {{- .Values.postgresql.primary.service.ports.postgresql -}}
          {{- else if and .Values.mysql.enabled (eq .Values.database "mysql") -}}
     {{- .Values.mysql.primary.service.port -}}
     {{- end -}}
{{- end -}}
{{- end -}}

{{/* use the default port */}}
{{- define "clusterpedia.storage.host" -}}
{{- if eq .Values.storageInstallMode "external" }}
     {{- .Values.external.host -}}
{{- else -}}
     {{- if and .Values.postgresql.enabled (eq .Values.database "postgresql") -}}
          {{- include "clusterpedia.postgresql.fullname" . -}}
     {{- else if and .Values.mysql.enabled (eq .Values.database "mysql") -}}
          {{- include "clusterpedia.mysql.fullname" . -}}
     {{- end -}}
{{- end -}}
{{- end -}}

{{- define "clusterpedia.storage.database" -}}
{{- if eq .Values.storageInstallMode "external" }}
     {{- .Values.external.database | quote -}}
{{- else -}}
     "clusterpedia"
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "clusterpedia.postgresql.fullname" -}}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "clusterpedia.mysql.fullname" -}}
{{- printf "%s-%s" .Release.Name "mysql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "clusterpedia.job.storage.fullname" -}}
{{- printf "%s-%s-%s-%s-%s" "check" .Values.persistenceMatchNode "local" "pv" "dir" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "clusterpedia.internalstorage.capacity" -}}
{{- if eq .Values.database "postgresql" -}}
{{- .Values.postgresql.persistence.size -}}
{{- else if eq .Values.database "mysql" -}}
{{- .Values.mysql.persistence.size -}}
{{- end -}}
{{- end -}}

{{- define "clusterpedia.storage.type" -}}
{{- if eq .Values.database "postgresql" -}}
{{- "postgres" -}}
{{- else -}}
{{- .Values.database -}}
{{- end -}}
{{- end -}}

{{- define "clusterpedia.storage.image" -}}
{{- if eq .Values.database "postgresql" -}}
{{- include "clusterpedia.storage.postgresql.image" . -}}
{{- else if eq .Values.database "mysql" -}}
{{- include "clusterpedia.storage.mysql.image" . -}}
{{- end -}}
{{- end -}}

{{- define "clusterpedia.storage.postgresql.image" -}}
{{- $registryName := .Values.postgresql.image.registry -}}
{{- $repositoryName := .Values.postgresql.image.repository -}}
{{- $tag := .Values.postgresql.image.tag -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}

{{- define "clusterpedia.storage.mysql.image" -}}
{{- $registryName := .Values.mysql.image.registry -}}
{{- $repositoryName := .Values.mysql.image.repository -}}
{{- $tag := .Values.mysql.image.tag -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}

{{- define "clusterpedia.storage.mountPath" -}}
{{- if eq .Values.database "postgresql" -}}
{{- "/bitnami/postgresql" -}}
{{- else if eq .Values.database "mysql" -}}
{{- "/bitnami/mysql" -}}
{{- end -}}
{{- end -}}

{{- define "clusterpedia.storage.hostPath" -}}
{{- printf "/var/local/clusterpedia/internalstorage/%s" .Values.database -}}
{{- end -}}

{{- define "clusterpedia.job.storage.password.key" -}}
{{- if eq .Values.database "postgresql" -}}
{{- "ALLOW_EMPTY_PASSWORD" -}}
{{- else if eq .Values.database "mysql" -}}
{{- "MYSQL_ROOT_PASSWORD" -}}
{{- end -}}
{{- end -}}

{{- define "clusterpedia.job.storage.password" -}}
{{- if eq .Values.database "postgresql" -}}
{{- "yes" -}}
{{- else if eq .Values.database "mysql" -}}
{{- "root" -}}
{{- end -}}
{{- end -}}
