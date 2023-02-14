echo '##### CREATING SCRATCH ORG #####'
sfdx force:org:create --definitionfile config/project-scratch-def.json --setalias REFRESH_API --setdefaultusername
echo '##### PUSHING METADATA #####'
sfdx force:source:push --targetusername REFRESH_API
echo '##### ASSIGNING PERMISSIONS #####'
sfdx force:user:permset:assign --perm-set-name Refresh_API --target-org REFRESH_API
echo '##### OPENING SCRATCH ORG #####'
sfdx force:org:open --path /lightning/o/Account/home --target-org REFRESH_API