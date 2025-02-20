# Kris Brown's forest

This is the source code for my [forest](https://www.forester-notes.org/) which is hosted on [my website](https://www.krisb.org/forest/index.xml).

Thank you to [Jon Sterling](https://www.jonmsterling.com/) and [Kento Okura](https://github.com/kentookura) for tireless work on making this excellent tool! Thank you to Owen Lynch for his contributions to forester in addition to making a lot of auxiliary support tools.

I hope this code can be of interest to others writing their own forests. Some interesting things to share:

# Why forester over alternatives?

- Free to use, open source
- Fast, pretty
- Transclusions done right
- Full LaTeX support, especially for diagrams
- Generates static website that can be shared
- Backlinks
- Collapsible nesting of subsections
- A relatively-flat hierarchy of atomic notes with internal linking via IDs (rather than via names) encourages [evergreen note-taking](https://www.forester-notes.org/tfmt-000R.xml), which maximizes reuse of notes.

# Custom relations

There are many relationships that hold between trees. In addition to the `links-to` and `transcludes`
relations that can occur between trees of any taxa, there are binary relations that obtain between trees of particular taxa:

- `author: Reference -> Person` (e.g. `author(Critique of Pure Reason, Kant)`)
- `dual: Concept -> Concept` (e.g. `dual(Product, Coproduct)`)
- `definition: Concept -> Definition` (connecting, e.g. the general page for `Category` with the specific tree containing a definition)
- `example: Concept -> Concept` (e.g. `example(SMC, Category)`, `example(Stone Duality, Equivalence of categories)`)
- `supports: Argument -> Argument` (e.g. `supports(Private language argument, Pragmatist theory of semantics)`) and `opposes`
- `source: [Any] -> Reference` (attributing credit to [nlab](https://ncatlab.org/nlab/show/HomePage) / [SEP](https://plato.stanford.edu/) / a paper)

Adding these relations to the datalog knowledge graph is accomplished with the following macro:

```
\def\relation[r][x][y]{
  \execute\datalog{
    \r @{\x} @{\y} -:
  }
}
```

For example:

```
\def\rel/dual{kris.dual}

\def\dual[x][y]{
\relation{\rel/dual}{\x}{\y}
\subtree{
  \title{Dual concept}
  \query\datalog{?X -: {\rel/dual @{\x} ?X}}}
}
```

Once forester gains a `current-tree` function, we can remove the `x` parameter.

Right now there is no notion of "schema" which would check that certain taxa have the expected relations.

# Internally-linked mathematical text

A mathematical expression packs a lot of content concisely into its symbols. These symbols, like "+", have meanings which depend on the context. LaTeX doesn't naturally support linking within its expressions such as $x^2$ (one has to accompany the expression with some text: "where the '2' refers to [exponentiation]). Better would be for the elements of the expression to be directly linked to what the notation stands for. 

For example, the "op" in Cofiltered Category (math-0099) is linked to the Opposite Category tree.

This is accomplished by building off of Jon Sterling's mathml macros file like so:

```
\def\op-link[addr][~C]{\ensure-math{\<mml:msup>{\C{} \<mml:mi>{[op](\addr)}}}}

\def\op-cat[~C]{\op-link{math-005U}{\C{}}}
```

# Wishlist

- A nice way to format (e.g. sensible indentation) the files in one's forest (I currently crudely use `latexindent`, see the `indentconfig.yaml` which I haven't spent much time towards configuring)
- Export to PDF