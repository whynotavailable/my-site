Welcome to my new website! I'm going to lay out here why I built it and how I chose the technologies used.

My experience in blogging/article software is relatively wide. Here is a non-exhaustive list of what I've tried and why I'm not using that tool.

* Wordpress: Too complicated to customize. I feel like you need to be an arcane wizard to understand its templating system.
* Ghost: It's fine, technically I could have built my CLI to point to ghost and it would work fine. I just don't want to pay them if I can build something myself.
* Medium: You can't customize Medium, and you also can't build categories of content (e.g. articles on programming and game reviews).
* Substack: Just a pain to use.
* Drupal: Nightmare to host for a low cost without using some sketchy company.
* Jekyll: No proper search, and static content growing linearly means performance and usability will just get worse over time.

Had the appropriate technologies not have presented themselves to me I'd probably just use Ghost. Luckily I heard about Turso.

## Data

My main problem with side projects where I need data is that data is actually kind of a pain. Your compute needs to connect to that data, and the database needs to not be terribly expensive. Tools like Aurora or other managed databases are way too expensive for a small blog. I could quite literally get a Kubernetes cluster and install a database on the cluster cheaper than most managed databases. 

Turso has a ton of limitations, it's sqlite, and sqlite is insanely limited in what you can do with it. In Postgres I can make HSTORE or ARRAY fields to make composable fields. As an example a tag field can be represented as an array of text and you can query for all rows with that contain a value. Sqlite has some work in the JSONB space that I'm looking forward to testing, but for now it's altered how I would normally design my data.

The reason I decided to use Turso is because it would work and not be terribly expensive. The free tier would have worked, but I paid the ten bucks so that I don't have a performance degradation caused by a sleepy database. If you have a need where sqlite would work, I'd give them a shot. I'll probably write an article purely about Turso later, but for now I'll leave it here.

## Languages

This is the list of programming languages I used.

* Rust
* HTML
* CSS

While there is JavaScript running on the page for Prism, I did not write any for this website. I also didn't use a CSS library. I did use the [Reset CSS](https://meyerweb.com/eric/tools/css/reset/) but outside of that I write everything myself. The colors were polled from [Coolors](https://coolors.co/palette/606c38-283618-fefae0-dda15e-bc6c25). I googled "website color palette generator" and Coolors popped up. I used the number one pallet since I liked the colors. I only ended up using two of them.

Rust I chose because I'm starting to like it and I wanted the challenge. It ended up being a slight pain because I over complicated it with a custom routing system and the documentation for `serde::de::DeserializeOwned` and `serde::Deserialize` when building generic functions that deserialize JSON objects not being terribly clear.

If you are interested in the code, a link can be found on my [about](/page/about) page.

While I wrote it in Rust on a whim, the performance is quite ridiculous, especially since I'm kind of shitty at it still. Even with nominal bot traffic hitting 150 times a minute every few hours I've not seen it go above 1.2 milli-cores or 8MB of working memory. Once I fixed the handlebars reloading problem it's remained under 6MB.

Running a fresh dotnet web api `dotnet new webapi --no-https` and hitting the example endpoint was 65-ish MB basically doing nothing. I can't easily test the CPU time since I suck at using top. I am **very** impressed with how easy it was to get it to perform fairly well.

## Compute

Hosting rust is actually fairly easy, I just needed a linux machine. Hosting rust and getting managed certs is not so easy. My preferred method of deployment is a container. I feel like it shouldn't be hard to deal with a container in a serverless environment. At work I use AWS, and AWS is basically garbage to operate on so that was straight up out. I ran a test to figure out what hosting platform I wanted to use. I made a super simple container that just responded on port 3000.

My initial pick was google cloud run as it maintained the certs for you automatically and it was serverless containers. My first issue was getting my container to GCP. For some reason you can only use a certain (very small) list of registries for your container. I was using GitHub Packages (since it was free) and that wasn't on the list. I did get the GCP build thing working by pointing it at my repo, but that was a huge pain.

My second issue is that I wanted to try out a CDN. I was unsuccessful in doing so. Their documentation was obtuse, and I got as far as it telling me I needed a private network to point the CDN at a public website until I gave up.

My second try was Azure Container Apps. This worked for my test pretty easily. While I did have some issues with my actual app due to not being able to create the app with secrets that was easily fixable. I was able to use my GitHub container with only one small issue. There are two fields for the container option. A login url and the actual image. You must not leave trailing or leading slashes in either field because Azure will put one there and if one exists it will fail silently. Setting up a CDN was also really easy, though I ended up not using it due to how little resources the site uses.

Pricing in container apps is slightly weird. I'm not going to really get an understanding until I start getting billed in a few days. At maximum it should still be cheaper than what I was paying for other managed blogs (and much less than how much I was paying to test them all). My current settings are 0.5 CPUs and 1 GB memory, from one to two instances scaling out if concurrent requests go above fifty. Not being able to see idle instances kind of sucks, and makes it hard to figure out how much it'll cost.

More than that, one metric I could really use is request length. I really don't want to build that into my app since it's less accurate than a proper response from the LB I know they are using.

So far though I'm happy with where it's at. I'll be adding a few extras like analytics and paging, but it's good enough for a few weeks to let it settle and write a few articles.