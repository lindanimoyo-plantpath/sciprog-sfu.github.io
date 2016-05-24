## Preview Before Merging

It's important to locally preview the changes before merging a pull request. This minimizes the risk that major issues make their way into the website. The following are steps to preview the website locally using Jekyll. 

1. Install Jekyll and associated dependencies with `gem install github-pages`. This will work well on OS X and Linux machines. My impression is that installing Jekyll on Windows machines is more of a hassle. 

2. Clone the repository and checkout the `merge_upstream` branch. 

  ```
  git clone https://github.com/sciprog-sfu/sciprog-sfu.github.io.git
  cd sciprog-sfu.github.io
  git checkout merge_upstream
  ```

3. Run Jekyll locally to preview the website using `jekyll serve`. 

4. Visit the indicated local server address, which usually is [http://127.0.0.1:4000/](http://127.0.0.1:4000/). 

**N.B.** Some links will not work locally, as they are updated dynamically to point to the repository's Issues page, which can only work when running on GitHub. This is expected. 
