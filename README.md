
# Docker Coming-Soon Generator

This project serves a "Coming Soon" page with content dynamically filled from environment variables. The default template is based on the [Bootstrap 4 Coming Soon](https://github.com/BlackrockDigital/startbootstrap-coming-soon) template and includes a Docker deploy script with a Twig template compiler, allowing you to quickly customize and deploy a page.

## Acknowledgments
- This project is forked from [roest01/docker-coming-soon-generator](https://github.com/roest01/docker-coming-soon-generator).

## Example
Here is an example of the resulting page:

![bootstrap4-example](https://github.com/TNCG-Admin/docker-coming-soon-generator/blob/master/templates/bootstrap4/example.png)

---

## Usage

To use this generator, set the environment variable `TEMPLATE` to select one of the available templates. If no template is specified, `bootstrap4` is used by default.

### Available Templates

| Template   | Preview                                                                                                                                | Description       |
|------------|----------------------------------------------------------------------------------------------------------------------------------------|-------------------|
| bootstrap4 | <img src="https://github.com/TNCG-Admin/docker-coming-soon-generator/blob/master/templates/bootstrap4/example.png" width="250"> | Default template  |
| bootstrap5 | <img src="https://github.com/TNCG-Admin/docker-coming-soon-generator/blob/master/templates/bootstrap5/example.png" width="250"> | Modern design     |
| blank      |                                                                                                                                        | Plain output      |

### Configuration Variables
The following environment variables can be used to configure the "Coming Soon" page:

| Variable Name   | Description                                   | Used In Templates   | Example                                                                 |
|-----------------|-----------------------------------------------|---------------------|-------------------------------------------------------------------------|
| TITLE           | Webpage head title and main heading          | bootstrap4/5, blank | Coming Soon!                                                           |
| SUBLINE         | Text under the title                         | bootstrap4/5, blank | We're working hard to finish the development of this site!             |
| MAIN_COLOR      | Primary color for the template               | bootstrap4/5, blank | #6c757d                                                                |
| VIDEO_URL       | Background video URL (internal or external)  | bootstrap5, blank   | mp4/bg.mp4                                                             |
| BACKGROUND_IMAGE| Background image URL                         | bootstrap4/5, blank | https://example.com/image.jpg                                          |
| FACEBOOK_URL    | Facebook page URL                            | bootstrap4/5, blank | https://www.facebook.com/yourPage                                      |
| TWITTER_URL     | Twitter page URL                             | bootstrap4/5, blank | https://www.twitter.com/yourPage                                       |
| GITHUB_URL      | GitHub repository URL                        | bootstrap4/5, blank | https://www.github.com/yourRepo                                        |

HTML is allowed in these variables for additional customization.

---

## Running with Docker
```bash
docker run -d \
  --name website \
  -e TEMPLATE=bootstrap5 \
  -e TITLE="Your custom <h4>TITLE</h4>" \
  -e SUBLINE="01234 / 5678910<br />mail@example.com <br /><br />Company: example <br />Your Name <br />Your Address. 00 <br />00000 Country" \
  tncgadmin/docker-coming-soon-generator
```

---

## Build Process
Occurs when run.sh is executed:
1. Clones the Bootstrap "Coming Soon" repository into a temporary directory.
2. Resets the repository to a specific commit for consistency.
3. Prepares the destination directory by ensuring it exists and clearing old content.
4. Moves the new template content from the temporary directory to the destination directory.
5. Cleans up the temporary directory to free up space.
6. Removes unnecessary files like checkout.sh if they exist.
7. Downloads and sets up the Twig template compiler (twigc) for processing templates.
8. Prepares the SCSS directory by removing any existing content and moving files from the selected template.
9. Checks for nginx.conf and moves it to the Nginx configuration directory if present.
10. Removes unused templates and directories to reduce clutter.
11. Creates a config.json file dynamically from environment variables if it doesn't already exist.
12. Compiles index.html.twig into a usable index.html using the config.json file.
13. Cleans up temporary directories and Git artifacts to tidy up the environment.
14. Checks if Nginx is already running and starts it only if necessary.
15. Prints a success message to indicate the process completed successfully.

---

## Frequently Asked Questions

### How do I change the background video in the `bootstrap4` or `bootstrap5` template?
Videos must be in MP4 format. You can configure the video in one of two ways:
1. Mount a volume into `/usr/share/nginx/html/mp4` and place your `bg.mp4` file there.
2. Set the `VIDEO_URL` environment variable to the URL of your video.

---

## Contributing
Contributions are welcome! If you want to add more templates or optimize the generator, feel free to contribute. To add a new template, include it in the `templates` folder, create an `index.html.twig` file, and document the relevant environment variables in this README.

