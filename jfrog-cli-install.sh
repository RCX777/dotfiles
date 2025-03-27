# Create the keyrings directory if it doesn't exist
sudo mkdir -p /usr/share/keyrings

# Download and save the JFrog GPG key to a keyring file
sudo rm -f /usr/share/keyrings/jfrog.gpg
wget -qO - https://releases.jfrog.io/artifactory/api/v2/repositories/jfrog-debs/keyPairs/primary/public | sudo gpg --dearmor -o /usr/share/keyrings/jfrog.gpg

# Add the JFrog repository to your APT sources with the signed-by option
echo "deb [signed-by=/usr/share/keyrings/jfrog.gpg] https://releases.jfrog.io/artifactory/jfrog-debs focal contrib" | sudo tee /etc/apt/sources.list.d/jfrog.list

# Update the package list
sudo apt update -y

# Install the JFrog CLI
sudo apt install -y jfrog-cli-v2-jf

