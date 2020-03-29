CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"

for pluginrc_file in $CURRENT_DIR/../../../plugins/*-bash-*/build/pluginrc.sh; do
  if [[ -f $pluginrc_file ]]; then
    plugin_name=`basename $(dirname $(dirname $pluginrc_file))`

    # Search EXE environment variables for plugin and execute
    plugin_env_name=`echo $plugin_name | tr '[:lower:]' '[:upper:]' | sed 's/-/_/g'`
    prefix="$plugin_env_name"_EXE_
    if [[ $XXH_VERBOSE == '2' ]]; then
      echo "Search $prefix*** environment for $plugin_name"
    fi
    for l in `env | grep $prefix`; do
      if [[ $XXH_VERBOSE == '2' ]]; then
        echo ENV $plugin_name: $l
      fi
      data="$( cut -d '=' -f 2- <<< "$l" )";
      code=`echo $data | base64 -d`
      if [[ $XXH_VERBOSE == '2' ]]; then
        echo ENV $plugin_name RUN: $code
      fi
      eval $code
    done

    if [[ $XXH_VERBOSE == '1' ]]; then
      echo Load plugin $pluginrc_file
    fi
    cd $(dirname $pluginrc_file)
    source $pluginrc_file
  fi
done

cd ~
