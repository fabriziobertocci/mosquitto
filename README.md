Mosquitto for Cosmopolitan
==========================

This is the branch that allow to build Mosiquitto for cross-platform library  [Cosmopolitan](https://github.com/jart/cosmopolitan)

To build, just follow the [same instructions as the main Mosquitto](README-compiling.md). 

For information about Mosquitto, please refer to the [Original repository](https://github.com/eclipse/mosquitto).



### Features & Limitations

* TLS is not supported
* No CJSON (yet)
* Multi-thread is not supported (as it is not supported by Cosmopolitan)
* Successfully build the following:
  * Mosquitto static library (no dynamic) `lib/libmosquitto.a`
  * Mosquitto broker (does not work - See below): `src/mosquitto`
  * Applications: `apps/db_dump/mosquitto_db_dump`
  * Client applications: `client/mosquitto_pub`, `client/mosquitto_sub`, `client/mosquitto_rr`



### Important notes:

* All the stand-alone application has been renamed to have the extension `.com` to allow to run on Windows.
* As mentioned in the Cosmopolitan project: _Please note that your APE binary will assimilate itself as a conventional resident of your platform after the first run, so it can be fast and efficient for subsequent executions. So if you intend to copy the binary to Windows or Mac then please **do that before you run it**, not after._



### Mosquitto Broker

Although the broker is successfully built, but because of the lack of support for shared library, the two source files `src/plugin.c` and `src/security.c` are essentially implementing empty stubs for the exported functions. As consequence, all the security-related functionality are going to fail.

One possible solution is to statically link with the broker all the security-related plugins and perform a selection at run-time through namespace. Further development is required.



### What can you do with it?

Not much at least until I can enable key functionalities like TLS and JSON... but eventually my goal is to be able to build MQTT command-line applications that can be natively 100% platform independent, fast and with minimal dependency with the system.

Think of running a docker container or a VM that contains only one application but it's few Kb instead of few Gb...