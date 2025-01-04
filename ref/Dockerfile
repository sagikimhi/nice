FROM mono:latest

RUN mkdir -p /docs

COPY . /

CMD [                                           \
    "mono",             "/nd/NaturalDocs.exe",  \
    "--tab-width",      "4",                    \
    "--source",         "/src",                 \
    "--project-config", "/ndconfig",            \
    "--output", "HTML", "/docs",                \
    "--rebuild"                                 \
]
