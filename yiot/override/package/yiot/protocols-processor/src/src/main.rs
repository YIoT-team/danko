fn main() {
    println!("YIoT CV-2SE Protocols converter");

    let mut count = 0u32;

    // Infinite loop
    loop {
        count += 1;
        println!("{}", count);

        // Sleep for 1 second
        std::thread::sleep(std::time::Duration::from_secs(1));
    }
}
