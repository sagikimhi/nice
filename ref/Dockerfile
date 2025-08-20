FROM mono:6.12.0

RUN mkdir -p /docs

COPY . /

CMD [ \
    "mono", \
    "/nd/NaturalDocs.exe", \
    "--tab-width", \
    "3", \
    "--source", \
    "/src", \
    "--project-config", \
    "/ndconfig", \
    "--output", \
    "HTML", \
    "/docs", \
    "--rebuild" \
    ]
