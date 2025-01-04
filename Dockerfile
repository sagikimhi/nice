FROM mono:latest

RUN mkdir /docs

COPY . /

CMD [                                           \
    "mono",             "/nd/NaturalDocs.exe",  \
    "--tab-width",      "4",                    \
    "--source",         "/src",                 \
    "--project-config", "/ndconfig",            \
    "--output", "HTML", "/docs",                \
    "--rebuild"                                 \
]
