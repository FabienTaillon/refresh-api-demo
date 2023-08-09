echo '##### CREATING SCRATCH ORG #####'
sf org create scratch --definition-file config/project-scratch-def.json --alias REFRESH_API --set-default 
echo '##### PUSHING METADATA #####'
sf project deploy start --target-org REFRESH_API
echo '##### ASSIGNING PERMISSIONS #####'
sf force user permset assign --perm-set-name Refresh_API --target-org REFRESH_API
echo '##### OPENING SCRATCH ORG #####'
sf org open --path /lightning/o/Account/home --target-org REFRESH_API