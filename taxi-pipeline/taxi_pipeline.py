"""REST API source for NYC taxi data from the Data Engineering Zoomcamp API."""

import dlt
from dlt.sources.rest_api import rest_api_resources
from dlt.sources.rest_api.typing import RESTAPIConfig


BASE_URL = "https://us-central1-dlthub-analytics.cloudfunctions.net/"
ENDPOINT_PATH = "data_engineering_zoomcamp_api"
PAGE_SIZE = 1000


@dlt.source
def taxi_pipeline():
    """Define dlt resources from the NYC taxi REST API (paginated JSON, 1000 records per page)."""
    config: RESTAPIConfig = {
        "client": {
            "base_url": BASE_URL,
        },
        "resources": [
            {
                "name": "trips",
                "endpoint": {
                    "path": ENDPOINT_PATH,
                    "data_selector": "$",
                    # Page size: use the param name your API expects (e.g. limit, size, per_page)
                    "params": {"size": PAGE_SIZE},
                    # PageNumberPaginatorConfig: type + optional base_page, page, page_param, total_path, maximum_page, stop_after_empty_page
                    "paginator": {
                        "type": "page_number",
                        "page_param": "page",
                        "base_page": 1,
                        "total_path": None,
                        "maximum_page": None,
                        "stop_after_empty_page": True,
                    },
                },
            },
        ],
    }

    yield from rest_api_resources(config)


pipeline = dlt.pipeline(
    pipeline_name="taxi_pipeline",
    destination="duckdb",
    progress="log",
)


if __name__ == "__main__":
    load_info = pipeline.run(taxi_pipeline())
    print(load_info)
