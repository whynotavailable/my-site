# Home

Here's the new website! Here's some code for testing!

```rust
let builder = Config::builder()
    .add_source(Environment::default())
    .add_source(File::new(
        root_path.join(".settings.json").to_str().unwrap(),
        FileFormat::Json,
    ));
```

I'm going to use this as a todo.

* Paging on the search.
* Bold (and probably italic) styles.
* Page title.
* Not shit error handling.
