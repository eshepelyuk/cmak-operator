{{- define "cmak.name" -}}
cmak
{{- end -}}

{{- define "cmak.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cmak.name" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end -}}

{{- define "cmak.labels" -}}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | quote }}
{{ include "cmak.selectorLabels" . }}
{{- end -}}

{{ define "cmak.consumerProperties" }}
{{ $default_props := dict "key.deserializer" "org.apache.kafka.common.serialization.ByteArrayDeserializer" "value.deserializer" "org.apache.kafka.common.serialization.ByteArrayDeserializer" -}}
{{ $consumer_propes := merge .Values.ui.consumerProperties $default_props -}}
{{- range $key, $val := $consumer_propes }}
{{ $key }}={{ $val -}}
{{- end }}
{{ if .Values.ui.consumerPropertiesSsl }}
{{- with .Values.ui.consumerPropertiesSsl -}}
ssl.truststore.location=/conf/ssl/truststore
ssl.truststore.type={{ .truststore.type }}
ssl.truststore.password= {{ .truststore.password }}
ssl.keystore.location=/conf/ssl/keystore
ssl.keystore.type={{ .keystore.type }}
ssl.keystore.password={{ .keystore.password }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "cmak.healthUi" -}}
{{ $httpCtx := "" }}
{{- range .Values.ui.extraArgs -}}
{{- if hasPrefix "-Dplay.http.context=" . -}}
{{- $httpCtx = trimPrefix "-Dplay.http.context=" . -}}
{{- end -}}
{{- end -}}
{{ $httpCtx }}/api/health
{{- end -}}
