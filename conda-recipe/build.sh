if [ "$(uname)" == "Darwin" ]
then
    LDFLAGS="-headerpad_max_install_names" \
    pip install --prefix=$PREFIX .
else
    pip install --prefix=$PREFIX .
fi
