import os
import argparse

def concatenate_verilog(folder_path, output_file="merged.v"):
    # Get all .v files in the folder, sorted alphabetically
    verilog_files = sorted([f for f in os.listdir(folder_path) if f.endswith(".v")])

    if not verilog_files:
        print("No .v files found in the folder.")
        return

    with open(output_file, "w") as outfile:
        for filename in verilog_files:
            file_path = os.path.join(folder_path, filename)
            with open(file_path, "r") as infile:
                outfile.write(f"// --- Start of {filename} ---\n")
                outfile.write(infile.read() + "\n")
                outfile.write(f"// --- End of {filename} ---\n\n")

    print(f"All .v files have been concatenated into {output_file}")

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Concatenate Verilog files in a folder into a single file.")
    parser.add_argument("-fp", "--folder_path", help="Path to the folder containing Verilog files")
    parser.add_argument("-o", "--output", default="merged.v", help="Output file name (default: merged.v)")

    args = parser.parse_args()

    concatenate_verilog(args.folder_path, args.output)
