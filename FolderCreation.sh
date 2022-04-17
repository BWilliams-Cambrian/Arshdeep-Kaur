#!/bin/bash
folderscreated=0
sudo mkdir -p /EmployeeData/{HR,IT,Finance,Executive,Administrative,'Call Centre'}
cd /EmployeeData
sudo chown :it IT
sudo chown :hr HR
sudo chown :finance Finance
sudo chown :executive Executive
sudo chown :administrative Administrative
sudo chown :callcentre 'Call Centre'

sudo chmod 764 -R IT
sudo chmod 764 -R Finance
sudo chmod 764 -R Administrative
sudo chmod 764 -R 'Call Centre'
sudo chmod 760 -R HR
sudo chmod 760 -R Executive 
echo "7 directories created"
