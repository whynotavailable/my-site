FROM ubuntu:16.04

# Update default packages
RUN apt-get -qq update

# Get Ubuntu packages
RUN apt-get install -y -q \
    build-essential \
    curl

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y

# Add .cargo/bin to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

COPY . .

# Check cargo is visible
RUN cargo install whynotblog@0.1.5


ENTRYPOINT ["whynotblog"]
