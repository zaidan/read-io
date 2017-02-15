# ReadIO - Read IO library
[![Hackage](https://img.shields.io/hackage/v/read-io.svg)](https://hackage.haskell.org/package/read-io)

A lightweight library to read and write data types deriving Read and Show.

## Usage
### Defining your data types
Define your data type deriving Read and Show:

```haskell
data Foo = Foo 
  { id :: Integer,
    name :: String,
    value :: Double,
    nested :: [(String, Bar)]
  }
  deriving (Read, Show, Eq) 

data Bar = Bar 
  { some :: Char
  }
  deriving (Read, Show, Eq) 
```

### Creating your data files
Create some data files you want to read - e. g. `data/a.foo`:
```haskell
Foo {
  id = 0,
  name = "a",
  value = 1.5,
  nested = [
    ("key 1", Bar { some = 'a'}),
    ("key 2", Bar { some = 'A'})
  ]
}

```

and `data/b.foo`:
```haskell
Foo {
  id = 1,
  name = "b",
  value = 3.1234567800009,
  nested = [
  ("key 1", Bar { some = 'b'}),
  ("key 2", Bar { some = 'B'})
  ]
}
```

### Read
Use
```haskell
foo <- System.IO.Read.readFrom "data/a.foo" :: IO Foo
```
to deserialize it to `IO Foo` or
```haskell
foos <- System.IO.Read.readDirectory "data"` :: IO [Foo]
```
to deserialize all containing files to `IO [Foo]`.

### Show
Use
```haskell
System.IO.Show.showFile foo "data/out.foo"
```
to serialize `foo` of type `Foo` to `data/out.foo`. 

## Credits

 * [Firas Zaidan](https://github.com/zaidan)

## License

See `LICENSE` file.
