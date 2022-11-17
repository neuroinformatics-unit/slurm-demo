import typer


def multiply(first_num: int, second_num: int, jazzy: bool = False):
    """
    Multiply two numbers together.
    If --jazzy is used, result is announced more grandly.
    """

    result = first_num * second_num
    if jazzy:
        print(f"Behold, the result is: {result}!")
    else:
        print(result)


if __name__ == "__main__":
    typer.run(multiply)