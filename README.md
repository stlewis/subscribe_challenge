# Subscribe Challenge

## Requirements

This project should execute just fine using any relatively recent version of Ruby. It was developed using 3.0.5p211.

If you want to run the specs, you'll need to execute `bundle install`inside the project directory to download RSpec and it's dependencies.

## Instructions

You can execute the program by calling:

```
ruby run.rb path/to/input/file.json
```

There are 3 sample JSON files located in the `/data` directory which correspond with the sample input provided in the challenge description. Any additional input JSON you'd like to use should follow the same formatting:

```
[
  {
    "quantity": Integer representing the number of items,
    "product": String representing the product name,
    "category": String representing the product category,
    "price": Currency-formatted string, (i.e. '12.30'), representing the product price,
    "imported": Boolean representing whether the product is imported
  },
]
```

Before being passed to the calculation step, the input JSON is validated against this schema. Missing keys or invalid data will result in failures being reported rather than the "Cart Summary".

Note that certain categories are "tax exempt". These are `books`, `food`, and `medical`. Spelling matters, but capitalization does not when providing an exempt category for a given line item in a cart.

## Output

Assuming you've provided a well-formatted and valid input file, the program will output a text summary of both the input values and the cart totals based upon all applied calculations:

```
Your Input Cart:
2 book at 12.49
1 music cd at 14.99
1 chocolate bar at 0.85

Your Output Summary:
2 book: 24.98
1 music cd: 16.49
1 chocolate bar: 0.85
Sales Taxes: 1.50
Total: 42.32

```

The requirements didn't explicitly call for the input to be printed back in this way, but I thought that it would make for convenient cross-checking.

### Assumptions

I made two key assumptions to get this working:

First, I assumed that it was okay to add a `category` and `imported` key to the input. These were added to facilitate tax exemptions and duty fees respectively. The alternative of using some kind of string-surgery to extract this metadata from the product name occurred to me, but I couldn't think of any reasonable way to do it, especially where "category" was concerned.

Second, since I was moving in the direction of more structured input anyway, I assumed that using JSON files as an input to the program was a reasonable choice.
