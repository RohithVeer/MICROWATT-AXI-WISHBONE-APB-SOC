import yaml

def load_yaml(filepath):
    with open(filepath, 'r') as f:
        return yaml.safe_load(f)

def generate_c_header(data, output_path):
    with open(output_path, 'w') as f:
        f.write("// Auto-generated from input.yaml\n")
        f.write("#ifndef DATA_GEN_H\n#define DATA_GEN_H\n\n")
        f.write("#include <stdint.h>\n\n")

        for i, entry in enumerate(data):
            pkg = entry.get("package", "unknown").replace("/", "_")
            ver = entry.get("version", "0.0.0")
            commit = entry.get("commit", "none")
            date = entry.get("date", "unknown")
            notes = entry.get("notes", [])

            f.write(f"// Package {pkg}\n")
            f.write(f'#define PKG_{i}_NAME "{pkg}"\n')
            f.write(f'#define PKG_{i}_VERSION "{ver}"\n')
            f.write(f'#define PKG_{i}_COMMIT "{commit}"\n')
            f.write(f'#define PKG_{i}_DATE "{date}"\n')

            for j, note in enumerate(notes):
                note_text = note.replace('"', '\\"').replace("\n", "\\n")
                f.write(f'#define PKG_{i}_NOTE_{j} "{note_text}"\n')

            f.write("\n")

        f.write("#endif // DATA_GEN_H\n")

if __name__ == "__main__":
    input_file = "input.yaml"
    output_file = "data_gen.h"
    data = load_yaml(input_file)
    generate_c_header(data, output_file)
    print(f" Generated C header: {output_file}")
