# Gentoo Overlay

Matteo Salonia's Gentoo Overlay

## Donate
Support this project: [salonia.it/donate](https://salonia.it/donate)

## Usage

### Manual way

Create the `/etc/portage/repos.conf/salonia.conf` file as follows:

```
[salonia]
priority = 50
location = /var/db/repos/salonia
sync-type = git
sync-uri = https://github.com/saloniamatteo/overlay.git
auto-sync = Yes
```

Then run `emaint sync -r salonia`, Portage should now find and update the repository.

### Eselect way

On terminal:

```bash
sudo eselect repository add salonia git https://github.com/saloniamatteo/overlay.git
```

And then run `emaint sync -r salonia`, Portage should now find and update the repository.

## Ebuilds

### open-fprintd & python-validity
These packages add support for Validity fingerprint sensors,
as found on **ThinkPad T460** & **T470** series laptops.

Original ebuilds written by
Mattéo Rossillol‑‑Laruelle ([@beatussum](https://github.com/beatussum)),
enhanced by Matteo Salonia ([@saloniamatteo](https://github.com/saloniamatteo)).

The exact hardware IDs supported currently by this project are the following:

```
138a:0090
138a:0097
06cb:009a
```

For more info, refer to
[open-fprintd](https://github.com/uunicorn/open-fprintd)
& [python-validity](https://github.com/uunicorn/python-validity)

In order to use it, follow these steps:
- Emerge the required packages (run as root):

  ```bash
  emerge fprintd open-fprintd python-validity
  ```

- Download the required firmware (run as root):

  ```bash
  validity-sensors-firmware
  ```

- Start the services (run as root):

  ```bash
  rc-service open-fprintd start
  rc-service python-validity start
  ```

- Enroll a fingerprint:

  ```bash
  fprintd-enroll <your-user> -f <your-finger>
  ```

  Example:

  ```bash
  fprintd-enroll matteo -f right-index-finger
  ```

If you have any issues with the fingerprint reader,
try to reset it with the following command (run as root):

```bash
python /usr/share/python-validity/playground/factory-reset.py
```

Wait a minute or so before trying the device again.

If you want to login using your fingerprint,
modify `/etc/pam.d/login` and prepend the following line:

```pam
auth	sufficient	pam_fprintd.so
```

Users that do not have a configured fingerprint will login normally.
