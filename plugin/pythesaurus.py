#!/usr/bin/env python
"""Gets thesaurus information about a word from thesaurus.com."""

import re
import urllib2
import vim

word = vim.eval('a:word').lower().strip()
response = urllib2.urlopen('http://www.thesaurus.com/browse/' + word)

ttl_re = re.compile(r'class="ttl">(.*)<')
layer_re = re.compile(r'layer disabled')
words_re = re.compile(r'words-gallery')
div_re = re.compile(r'</div>')
text_re = re.compile(r'class="text">(.*)<')
relevancy_re = re.compile(r'relevancy-list')
holder_re = re.compile(r'list-holder')

definition = ' '
synonyms = []
antonyms = []
flag = 0

for line in response:
    if flag == 0:
        if definition.isspace() and words_re.search(line):
            flag = 1  # definition
        elif relevancy_re.search(line):
            flag = 2  # synonyms
        elif holder_re.search(line):
            flag = 3  # antonyms
    elif flag == 1:  # definition
        m = ttl_re.search(line)
        if m:
            definition = m.group(1)
            flag = 0
        elif layer_re.search(line):
            flag = 0
    elif flag == 2:  # synonyms
        m = text_re.search(line)
        if m:
            synonyms.append(m.group(1))
        elif div_re.search(line):
            flag = 0
    elif flag == 3:  # antonyms
        m = text_re.search(line)
        if m:
            antonyms.append(m.group(1))
        elif div_re.search(line):
            flag = 0

vim.current.buffer.append('Main Entry: %s' % word, vim.current.range.start)
vim.current.buffer.append('Definition: %s' % definition)
vim.current.buffer.append('')
vim.current.buffer.append('Synonyms: %s' % ', '.join(synonyms))
vim.current.buffer.append('')
vim.current.buffer.append('Antonyms: %s' % ', '.join(antonyms))
