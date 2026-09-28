import re
import pandas as pd


def normalize(name):
    """Lowercase, collapse whitespace, remove non-breaking spaces."""
    name = str(name)
    name = name.replace("\xa0", " ")        # non-breaking space -> normal space
    name = re.sub(r"\s+", " ", name)         # collapse multiple spaces
    return name.strip().lower()


COLUMN_MAP = {
    normalize("Date/Time"): "timestamp",
    normalize("SubLoop1-Coolant Return Temp"): "s1_return_temp",
    normalize("SubLoop1-Coolant FLow"): "s1_flow",
    normalize("SubLoop2-Coolant Return Temp"): "s2_return_temp",
    normalize("SubLoop2-Coolant FLow"): "s2_flow",
    normalize("SubLoop3-Coolant Return Temp"): "s3_return_temp",
    normalize("SubLoop3-Coolant FLow"): "s3_flow",
    normalize("Overall-average Coolant Return Temp"): "avg_return_temp",
    normalize("Overall Coolant Supply Temp"): "supply_temp",
    normalize("Overall Coolant FLow"): "total_flow",
    normalize("SubLoop1_WasteHeat"): "s1_heat",
    normalize("SubLoop2_WasteHeat"): "s2_heat",
    normalize("SubLoop3_WasteHeat"): "s3_heat",
    normalize("Overall_WasteHeat"): "total_heat",
    normalize("Frontier Compute Power"): "compute_power",
    normalize("Frontier Facility accessory Power"): "accessory_power",
    normalize("Frontier Total Power"): "total_power",
    normalize("Power Usage Effectiveness"): "pue",
}


def load_raw(path="data/raw/frontier_2023.xlsx"):
    df = pd.read_excel(path, header=0)
    df = df.iloc[1:].reset_index(drop=True)   # drop units row

    # Normalize and rename
    df.columns = [normalize(c) for c in df.columns]
    df = df.rename(columns=COLUMN_MAP)

    # Parse timestamp
    df["timestamp"] = pd.to_datetime(df["timestamp"], errors="coerce")

    # Convert numeric columns
    for col in df.columns:
        if col != "timestamp":
            df[col] = pd.to_numeric(df[col], errors="coerce")

    return df


if __name__ == "__main__":
    df = load_raw()
    print("Shape:", df.shape)
    print("\nDtypes:")
    print(df.dtypes)
    print("\nHead:")
    print(df.head())
    print("\nMissing values per column:")
    print(df.isna().sum())