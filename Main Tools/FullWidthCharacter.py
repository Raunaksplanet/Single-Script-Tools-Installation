import sys

def to_fullwidth(text):
    fullwidth_text = ''
    for char in text:
        code = ord(char)
        if char == ' ':
            # Half-width space to full-width space
            fullwidth_text += '\u3000'
        elif 0x21 <= code <= 0x7E:
            # Convert ASCII characters to full-width
            fullwidth_text += chr(code + 0xFEE0)
        else:
            # Leave other characters unchanged
            fullwidth_text += char
    return fullwidth_text

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python to_fullwidth.py <text>")
        sys.exit(1)
    
    input_text = ' '.join(sys.argv[1:])
    output_text = to_fullwidth(input_text)
    print(output_text)
