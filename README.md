<p align="center"><img src="logo.png" width="400"></p>

# diploma-bachelor

This diploma project is designed to interactively demonstrate the main aspects of information security using the most popular and demanded open source utilities.

## Graduate Documents

See [Diploma](scans/diploma.pdf), [Diploma Supplement](scans/diploma_supplement.pdf).

## Usage

1. Install [Docker](https://docs.docker.com/engine/installation/), [Docker Compose](https://docs.docker.com/compose/install/) and [Task](https://taskfile.dev/#/installation);

2. Clone this project and then cd to the project folder;

3. Run the initial build of the environment:
```sh
$ task init
```

4. Now you just need to run the application:
```sh
$ task run
```

5. After finishing work, you can stop running containers:
```sh
$ task stop # to just stop running application
$ task down # also stop and remove containers
```

## List of used applications

1. Core
   * [bash](https://www.gnu.org/software/bash/)
   * [dialog](https://invisible-island.net/dialog/#download)

2. Module:encryption
   * [truecrypt](https://www.truecrypt71a.com/downloads/)
   * [veracrypt](https://www.veracrypt.fr/en/Downloads.html)

3. Module:network
   * [curl](https://curl.se/download.html)
   * [python3](https://www.python.org/downloads/)
   * [pip3 for python3](https://pip.pypa.io/en/stable/installing/)
   * [gunicorn for python3](https://gunicorn.org/)
   * [httperf](https://github.com/httperf/httperf)
   * [nmap](https://nmap.org/download.html)
   * [siege](https://github.com/JoeDog/siege)

  > Note that you also have ability to use python venv test server for testing purposes: [diploma-bachelor-nms](https://github.com/andinoriel/diploma-bachelor-nms)

4. Module:restore
   * [ext4magic](https://sourceforge.net/projects/ext4magic/)
   * [foremost](https://sourceforge.net/projects/foremost/)
   * [scalpel](https://github.com/sleuthkit/scalpel)


## Test server benchmarking

You can use benchmark for provided test server using it as a containerized docker image and testing it using (Google cAdvisor)[https://github.com/google/cadvisor]. For this:

1. Install [docker](https://docs.docker.com/engine/installation/) and [docker-compose](https://docs.docker.com/compose/install/);

2. Run the initial build of the environment for the test server:
```sh
$ cd ./extern
$ task init
```

3. Run the test server and Google cAdvisor utility:
```sh
$ task run
```

4. Test server is now online and await for clients on http://127.0.0.1:4723; you can inspect the running containerized test server on http://127.0.0.1:8080/docker/ - just choose the 'extern-diploma-bachelor-server-1'.

5. After finishing work, you can stop running containers:
```sh
$ task stop # to just stop running applications
$ task down # also stop and remove containers
```

## Screenshots

<details>
  <summary>Expand</summary>

  <p align="center">
    <img src="screenshots/Ask root.png" width="1280"/>
    <img src="screenshots/1 - hello1.png" width="1280"/>
    <img src="screenshots/1 - hello2.png" width="1280"/>
    <img src="screenshots/2 - Main menu.png" width="1280"/>
    <img src="screenshots/2.1 - Menu.png" width="1280"/>
    <img src="screenshots/2.1.1 - Menu.png" width="1280"/>
    <img src="screenshots/2.1.1.1 - Menu.png" width="1280"/>
    <img src="screenshots/2.1.1.1 - FD path dialog.png" width="1280"/>
    <img src="screenshots/2.1.1.1 - Algorithm dialog.png" width="1280"/>
    <img src="screenshots/2.1.1.1 - Password dialog.png" width="1280"/>
    <img src="screenshots/2.1.1.1 - Encryption.png" width="1280"/>
    <img src="screenshots/2.1.2 - Benchmark.png" width="1280"/>
    <img src="screenshots/2.2 - Menu.png" width="1280"/>
    <img src="screenshots/2.2.1 - Menu.png" width="1280"/>
    <img src="screenshots/2.2.1 - Scan.png" width="1280"/>
    <img src="screenshots/2.2.2 - Menu.png" width="1280"/>
    <img src="screenshots/2.2.2 - Test.png" width="1280"/>
    <img src="screenshots/2.2.3 - Menu.png" width="1280"/>
    <img src="screenshots/2.2.3 - Test.png" width="1280"/>
    <img src="screenshots/2.3 - Menu.png" width="1280"/>
    <img src="screenshots/2.3.1 - Menu.png" width="1280"/>
    <img src="screenshots/2.3.1 - Restore.png" width="1280"/>
    <img src="screenshots/2.3.2 - Restore.png" width="1280"/>
    <img src="screenshots/2.3.3 - Restore.png" width="1280"/>
    <img src="screenshots/cAdvisor - CPU.png" width="1280"/>
    <img src="screenshots/cAdvisor - Memory.png" width="1280"/>
    <img src="screenshots/cAdvisor - Network.png" width="1280"/>
  </p>
</details>

## Credits

My thanks to the developers of the [Docker](https://www.docker.com/company), [Bash](https://www.gnu.org/software/bash/) and [Python](https://www.python.org/psf-landing/).

Also thanks to the developers of all the utilities mentioned in the [List of used applications](#List-of-used-applications) section

## License

This project is licensed under the [MIT License](LICENSE).
