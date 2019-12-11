FROM node:10.15.3

RUN yarn global add yarn@1.19.1

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
  && apt-get update \
  && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /workspace
WORKDIR /workspace
COPY . /workspace/

RUN cd /workspace/app && yarn

# Add user so we don't need puppeteer --no-sandbox.
RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
  && mkdir -p /home/pptruser/Downloads \
  && chown -R pptruser:pptruser /home/pptruser \
  && chown -R pptruser:pptruser /workspace/

RUN cd /workspace/app/node_modules/puppeteer/.local-chromium/linux-706915/chrome-linux/ \
  && chown root:root chrome_sandbox \
  && chmod 4755 chrome_sandbox \
  && cp -p chrome_sandbox /usr/local/sbin/chrome-devel-sandbox

ENV CHROME_DEVEL_SANDBOX="/usr/local/sbin/chrome-devel-sandbox"

USER pptruser
