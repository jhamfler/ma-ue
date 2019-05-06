#!/bin/bash
#./test --target "https://127.0.0.1:4430/nnrf-disc/v1/nf-instances?target-nf-type=AUSF&requester-nf-type=AMF"
#./test --target "https://127.0.0.1:4430/nudm-ueau/v1/suci-0-262-01-1111-0-0-0000000000/security-information/generate-auth-data" # suci 29.503f30p169

# nrf not implemented
#curl -v --http2 --insecure "https://127.0.0.1:4430/nnrf-disc/v1/nf-instances?target-nf-type=AUSF&requester-nf-type=AMF&service-names=nausf-auth,nssf"

# 8 from amf
curl -v --http2 --insecure "https://127.0.0.1:4430/nausf-auth/v1/ue-authentications" -X POST -H "Content-Type: application/json" -d '{"servingNetworkName":"5G:mnc000.mcc000.3gppnetwork.org", "supiOrSuci":"suci-0-262-01-1111-0-0-0000000000"}'
# 12 from ausf
#curl -v --http2 --insecure "https://127.0.0.1:4430/nudm-ueau/v1/suci-0-262-01-1111-0-0-0000000000/security-information/generate-auth-data" -X POST -H "Content-Type: application/json" -d '{"servingNetworkName":"5G:mnc000.mcc000.3gppnetwork.org", "ausfInstanceId":"00000000-0000-0000-0000-000000000000"}'
# 21 from amf
curl -v --http2 --insecure "https://127.0.0.1:4430/nausf-auth/v1/ue-authentications/authctxid0123456789/eap-session" -X POST -H "Content-Type: application/json" -d '{eapPayload: "MDAwMDExMTExMTExMTExMTExMTExMTExMTExMTExMTExMTExMTExMTExMTExMTEx"}'

# 29 from amf
curl -v --http2 --insecure "https://127.0.0.1:4430/nudm-ueau/v1/imsi-012345678901234/registrations/amf-3gpp-access" -X PUT -H "Content-Type: application/json" -d '{"amfInstanceId": "00000000-0000-0000-0000-000000000000", "deregCallbackUri": "https://127.0.0.1:4430/someamfuri", "guami": {"plmnId": {"mcc": "000", "mnc": "000"}, "amfId": "01abcd"}, "ratType": "NR"}'

# 32
curl -v --http2 --insecure 'https://127.0.0.1:4430/nudm-sdm/v2/imsi-012345678901234/am-data' # as no plmnid andso on: uses hplmn
curl -v --http2 --insecure 'https://127.0.0.1:4430/nudm-sdm/v2/imsi-012345678901234/smf-select-data'
curl -v --http2 --insecure 'https://127.0.0.1:4430/nudm-sdm/v2/imsi-012345678901234/ue-context-in-smf-data'

# 38 (new: )
curl -v --http2 --insecure 'https://127.0.0.1:4430/nudm-sdm/v2/imsi-012345678901234/sdm-subscriptions' -X POST -H "Content-Type: application/json" -d '{"nfInstanceId": "0000", "callbackReference": "https://amf.domain.tld/notifications/11111", "monitoredResourceUris": ["https://udm.domain.tld/nudm-ueau/v1/imsi-012345678901234/smf-select-data", "https://udm.domain.tld/nudm-ueau/v1/imsi-012345678901234/am-data", "https://udm.domain.tld/nudm-ueau/v1/imsi-012345678901234/ue-context-in-smf-data"]}'

# 46 (new: )
curl -v --http2 --insecure 'https://127.0.0.1:4430/npcf-ue-policy-control/v1/policies' -X POST -H "Content-Type: application/json" -d '{"notificationUri": "https://amf.domain.tld/notifications/22222", "supi": "imsi-012345678901234", "suppFeat": "0"}'
