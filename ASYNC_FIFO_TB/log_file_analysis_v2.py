import re
import os

# This code displays write and read side by side with alignment issues

def parse_vcs_log(filename):
    """
    Parse VCS simulation log and extract WRITING/STORING statements with timing data.
    Returns organized lists for read and write operations.
    """

    writing_read = []
    writing_write = []
    storing_read = []
    storing_write = []

    try:
        with open(filename, 'r') as f:
            for line in f:
                # Extract WRITING statements
                if 'WRITING INTO QUEUE' in line:
                    match = re.match(r'(\d+)\s*:\s*WRITING INTO QUEUE Storing (\d+) into (write_txQ)', line)
                    if match:
                        timestamp = match.group(1)
                        value = match.group(2)
                        writing_write.append({
                            'timestamp': int(timestamp),
                            'value': int(value),
                            'raw': line.strip()
                        })

                # Extract STORING statements
                elif 'STORING QUEUE' in line:
                    match = re.match(r'(\d+)\s*:\s*STORING QUEUE Storing (\d+) into (read_txQ)', line)
                    if match:
                        timestamp = match.group(1)
                        value = match.group(2)
                        storing_read.append({
                            'timestamp': int(timestamp),
                            'value': int(value),
                            'raw': line.strip()
                        })

    except FileNotFoundError:
        print(f"Error: File '{filename}' not found")
        return None

    return {
        'writing_write': writing_write,
        'storing_read': storing_read,
        'writing_read': writing_read,
        'storing_write': storing_write
    }


def print_summary(data):
    """Print summary of parsed data."""
    print(f"\n{'=' * 60}")
    print("PARSED LOG SUMMARY")
    print(f"{'=' * 60}")
    print(f"WRITING (Write Operations): {len(data['writing_write'])} entries")
    print(f"STORING (Read Operations):  {len(data['storing_read'])} entries")
    print(f"{'=' * 60}\n")


from itertools import zip_longest

def print_writing_write(data):
    """Print all WRITING statements for write operations."""
    count = 0

    print(f"\n{'=' * 60}")
    print("WRITING INTO QUEUE (Write Operations)")
    print(f"{'=' * 60}")
    print("COUNT \t DATA_WRITTEN \t TIME")

    for write_entry, read_entry in zip_longest(
        data['writing_write'],
        data['storing_read'],
        fillvalue=None
    ):
        if write_entry is not None:
            print(
                f"{count} \t | {write_entry['value']:5d} | \t "
                f"{write_entry['timestamp']:6d} ns | ", end = ""
            )
            # count += 1

        if read_entry is not None:
            print(
                f"\t {count} \t | {read_entry['value']:5d} | \t "
                f"{read_entry['timestamp']:6d} ns"
            )
        # To accommodate for more write entries than read as writes entries printer does not have \n
        if read_entry is None:
            print("")
        # To accommodate for more read entries than write as read entries printer must print after some places
        if write_entry is None:
            print("\t\t\t\t\t")
        count += 1

    print(
        f"\n{len(data['writing_write'])} write entries | "
        f"{len(data['storing_read'])} read entries\n"
    )



def print_storing_read(data):
    """Print all STORING statements for read operations."""
    count = 0
    print(f"\n{'=' * 60}")
    print("STORING QUEUE (Read Operations)")
    print(f"{'=' * 60}")
    for entry in data['storing_read']:
        print(f"{count} \t | {entry['value']:5d} | \t {entry['timestamp']:6d} ns ")
        count += 1
    print(f"Total: {len(data['storing_read'])} entries\n")


def print_all_raw(data):
    """Print raw log lines as they appear."""
    print(f"\n{'=' * 60}")
    print("ALL RAW LOG ENTRIES")
    print(f"{'=' * 60}\n")

    print("WRITING INTO QUEUE:")
    for entry in data['writing_write']:
        print(entry['raw'])

    print("\n\nSTORING QUEUE:")
    for entry in data['storing_read']:
        print(entry['raw'])


# Main execution
if __name__ == "__main__":
    # Parse the log file
    print(os.getcwd())

    # Change Directory
    os.chdir("/Users/Siddharth1/Downloads/result 2")
    log_file = "sim_output.log"
    data = parse_vcs_log(log_file)

    if data:
        # Print summary
        print_summary(data)

        # Print formatted lists
        print_writing_write(data)
        # print_storing_read(data)

        # Uncomment to print raw format
        # print_all_raw(data)

        # You can also access the lists directly:
        # print(data['writing_write'])
        # print(data['storing_read'])