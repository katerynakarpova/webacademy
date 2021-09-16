# Markdown heading

<h2>18.6 Commit best practices</h2>

<https://github.com/katerynakarpova/webacademy/tree/main/homework_1>

Ideally, each commit should be minimal but complete:

Minimal: A commit should only contain changes related to a single problem. This will make it easier to understand the commit at a glance, and to describe it with a simple message. If you should discover a new problem, you should do a separate commit.

Complete: A commit should solve the problem that it claims to solve. If you think you’ve fixed a bug, the commit should contain a unit test that confirms you’re right.

Each commit message should:

Be concise, yet evocative. At a glance, you should be able to see what a commit does. But there should be enough detail so you can remember (and understand) what was done.

Describe the why, not the what. Since you can always retrieve the diff associated with a commit, the message doesn’t need to say exactly what changed. Instead it should provide a high-level summary that focuses on the reasons for the change.

If you do this:

It’ll be easier to work with others. For example, if two people have changed the same file in the same place, it’ll be easier to resolve conflicts if the commits are small and it’s clear why each change was made.

Project newcomers can more easily understand the history by reading the commit logs.

You can load and run your package at any point along its development history. This can be tremendously useful with tools like bisectr, which allow you to use binary search to quickly find the commit that introduced a bug.

If you can figure out exactly when a bug was introduced, you can easily understand what you were doing (and why!).

You might think that because no one else will ever look at your repo, that writing good commit messages is not worth the effort. But keep in mind that you have one very important collaborator: future-you! If you spend a little time now polishing your commit messages, future-you will thank you if and when they need to do a post-mortem on a bug.

Remember that these directives are aspirational. You shouldn’t let them get in your way. If you look at the commit history of my repositories, you’ll notice a lot of them aren’t that good, especially when I start to get frustrated that I still haven’t managed to fix a bug. Strive to follow these guidelines, and remember it’s better to have multiple bad commits than to have one perfect commit.
