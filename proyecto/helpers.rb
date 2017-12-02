
def valid_name(string)
    string.match? (/^(([a-z]|[0-9]|_)+)$/i)
end
