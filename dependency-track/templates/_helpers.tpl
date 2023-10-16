{{/* vim: set filetype=mustache: */}}

{{- define "apiserver.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.apiserver.image "global" .Values.global ) -}}
{{- end -}}

{{- define "frontend.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.frontend.image "global" .Values.global ) -}}
{{- end -}}

{{- define "frontend.labels.standard" -}}
{{ include "common.labels.standard" . }}
app.kubernetes.io/component: frontend
{{- end -}}

{{- define "frontend.labels.matchLabels" -}}
{{ include "common.labels.matchLabels" . }}
app.kubernetes.io/component: frontend
{{- end -}}

{{- define "backend.labels.standard" -}}
{{ include "common.labels.standard" . }}
app.kubernetes.io/component: backend
{{- end -}}

{{- define "backend.labels.matchLabels" -}}
{{ include "common.labels.matchLabels" . }}
app.kubernetes.io/component: backend
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "frontend.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.frontend.image) "global" .Values.global) }}
{{- end -}}


{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "backend.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.apiserver.image) "global" .Values.global) }}
{{- end -}}

