# HMS
## Honeynet Management Suite - Bash scripting to ease the installation of a honeynet.

The Honeynet Management Suite is a set of scripts designed to aid the deployment of a Honeynet for security research purposes. These scripts should allow users to deploy sensors and other tools in order to aid gather intelligence on the types of Tactics, Techniques and Procedures utilised by attackers.

## Getting Started

These scripts have been tested and built using Ubuntu 16.04 LTS VPS builds. To ensure a smooth deployment, it is recommended that the same configuration is utilised when using these scripts.

## Features
* Deploy [Snake](https://github.com/countercept/snake)
* Deploy [Malware Repository Framework (MRF)](https://github.com/Tigzy/malware-repo)
* Deploy [Modern Honey Network (MHN)](https://github.com/threatstream/mhn)

## Installing

A step by step series of examples that tell you have to get a development env running

Install Git:

```
sudo apt-get install git -y

```

Clone Repository:
```
sudo git clone https://github.com/Schillers/HMS.git
cd HMS/
```

For the management server, deploy the tools:

```
sudo ./build-management-server.sh
```

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments
* [Snake](https://github.com/countercept/snake)
* [Malware Repository Framework (MRF)](https://github.com/Tigzy/malware-repo)
* [Modern Honey Network (MHN)](https://github.com/threatstream/mhn)
