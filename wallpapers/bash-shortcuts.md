# How-to: Bash Keyboard Shortcuts

## Moving the cursor:

```
  Ctrl + a   Go to the beginning of the line (Home)
  Ctrl + e   Go to the End of the line (End)
  Ctrl + p   Previous command (Up arrow)
  Ctrl + n   Next command (Down arrow)
   Alt + b   Back (left) one word
   Alt + f   Forward (right) one word
  Ctrl + f   Forward one character
  Ctrl + b   Backward one character
  Ctrl + xx  Toggle between the start of line and current cursor position
```

## Editing:

```
 Ctrl + L   Clear the Screen, similar to the clear command

  Alt + Del DELETE the WORD BEFORE the cursor.
  Alt + d   DELETE the WORD AFTER the cursor.
 Ctrl + d   DELETE CHARACTER UNDER the cursor
 Ctrl + h   DELETE CHARACTER BEFORE the cursor (Backspace)

 Ctrl + w   CUT the WORD BEFORE the cursor to the clipboard.
 Ctrl + k   CUT the LINE AFTER the cursor to the clipboard.
 Ctrl + u   CUT/DELETE the WHOLE LINE the cursor to the clipboard.

  Alt + t   SWAP CURRENT WORD with previous
 Ctrl + t   SWAP the LAST TWO CHARACTERS before the cursor (typo).
 Esc  + t   SWAP the LAST TWO WORDS before the cursor.

 ctrl + y   Paste the last thing to be cut (yank)
  Alt + u   UPPER capitalize every character from the cursor to the end of the current word.
  Alt + l   Run `ls`
  Alt + c   Capitalize the character under the cursor and move to the end of the word.
  Alt + r   ...
 ctrl + _   Undo
 
 TAB        Tab completion for file/directory names
```

## Special keys: Tab, Backspace, Enter, Esc

```
Text Terminals send characters (bytes), not key strokes.
Special keys such as Tab, Backspace, Enter and Esc are encoded as control characters.
Control characters are not printable, they display in the terminal as ^ and are intended to have an effect on applications.

Ctrl+I = Tab
Ctrl+J = Newline
Ctrl+M = Enter
Ctrl+[ = Escape

Many terminals will also send control characters for keys in the digit row:
Ctrl+2 → ^@
Ctrl+3 → ^[ Escape
Ctrl+4 → ^\
Ctrl+5 → ^]
Ctrl+6 → ^^
Ctrl+7 → ^_ Undo
Ctrl+8 → ^? Backward-delete-char

Ctrl+v tells the terminal to not interpret the following character, so Ctrl+v Ctrl-I will display a tab character,
similarly Ctrl+v ENTER will display the escape sequence for the Enter key: ^M
```

## History:

```
  Ctrl + r   Recall the last command including the specified character(s)
             searches the command history as you type.
             Equivalent to : vim ~/.bash_history. 
  Ctrl + p   Previous command in history (i.e. walk back through the command history)
  Ctrl + n   Next command in history (i.e. walk forward through the command history)

  Ctrl + s   Go back to the next most recent command.
             (beware to not execute it from a terminal because this will also launch its XOFF).
  Ctrl + o   Execute the command found via Ctrl+r or Ctrl+s
  Ctrl + g   Escape from history searching mode
        !!   Repeat last command
      !n     Repeat from the last command: args n e.g. !:2 for the second argumant.
      !n:m   Repeat from the last command: args from n to m. e.g. !:2-3 for the second and third.
      !n:$   Repeat from the last command: args n to the last argument.
      !n:p   Print last command starting with n        !$   Last argument of previous command   ALT + .   Last argument of previous command        !*   All arguments of previous command^abc­^­def   Run previous command, replacing abc with def
```

## Process control:

```
 Ctrl + C   Interrupt/Kill whatever you are running (SIGINT)
 Ctrl + l   Clear the screen
 Ctrl + s   Stop output to the screen (for long running verbose commands)
            Then use PgUp/PgDn for navigation
 Ctrl + q   Allow output to the screen (if previously stopped using command above)
 Ctrl + D   Send an EOF marker, unless disabled by an option, this will close the current shell (EXIT)
 Ctrl + Z   Send the signal SIGTSTP to the current task, which suspends it.
            To return to it later enter fg 'process name' (foreground).
```