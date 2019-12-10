FROM uber/web-base-image:10.15.2

RUN mkdir /workspace
WORKDIR /workspace
COPY . /workspace/

# Add user so we don't need puppeteer --no-sandbox.
RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
  && mkdir -p /home/pptruser/Downloads \
  && chown -R pptruser:pptruser /home/pptruser \
  && chown -R pptruser:pptruser /workspace/node_modules

USER pptruser
