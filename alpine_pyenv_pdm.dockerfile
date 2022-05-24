# Dockerfile that runs Python on Alpine Linux and uses pyenv and pdm
FROM alpine:latest

ARG python_version=3.8.13

# Python Install Dependencies for Alpine
RUN apk add --no-cache git bash build-base \
        libffi-dev openssl-dev bzip2-dev zlib-dev xz-dev \
        readline-dev sqlite-dev tk-dev curl

# Pyenv and PDM
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \ 
    cd ~/.pyenv && src/configure && make -C src && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc && \
    source ~/.bashrc && \
    pyenv install $python_version && \
    pyenv global $python_version && \

    # PDM
    curl -sSL https://raw.githubusercontent.com/pdm-project/pdm/main/install-pdm.py | python3 - && \
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && \
    source ~/.bashrc && \
    pdm --pep582 bash >> ~/.bashrc
    source ~/.bashrc && \
    # pdm completion bash > /etc/bash_completion.d/pdm.bash-completion

# Global Python Packages and Libraries
VOLUME /root/work
WORKDIR /root
COPY ./.pdm .

RUN source ~/.bashrc && \
    pdm install -g

CMD ["/bin/bash"]
