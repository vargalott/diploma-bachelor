#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

init() {
  python -m venv $PROJ_ROOT_DIR/extern/server/env
  source $PROJ_ROOT_DIR/extern/server/env/bin/activate
  pip install -r $PROJ_ROOT_DIR/extern/server/requirements.txt
}

run() {
  cd $PROJ_ROOT_DIR/extern/server/
  python -m diploma-nms
}

RESOLVE_FUNC_CALL $@