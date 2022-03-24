global css body
	background-color: black
	overflow: hidden
	margin: 0
	height: 100vh
	width: 100vw

def random_int(min, max)
	min + Math.floor( Math.random() * (max - min + 1) )

def random_katakana
	String.fromCharCode(random_int(0x30A0, 0x30FF))

def random_symbols
	for i in [0 .. random_int(5, 30)]
		{ v: random_katakana() }

tag stream
	prop x
	prop y
	prop symbols

	<self[top:{y}px left:{x}px]>
		for symbol, index in symbols
			<div.symbol>
				symbol.v

	css
		position: absolute
		display: flex
		flex-direction: column-reverse

		.symbol
			height: 20px
			width: 20px
			line-height: 20px
			position: relative
			font-size: 16px
			text-align: center
			color: #8f4

			&:first-child
				color: #dfa

tag app
	def setup
		streams = []
		let x = 10
		while x + 30 < window.innerWidth
			streams.push({
				x: x
				y: Math.random() * window.innerHeight
				speed: 3 + Math.random() * 5
				symbols: random_symbols()
			})
			x += 30

	def mount
		imba.setInterval(&, 10) do
			for stream in streams
				stream.y += stream.speed
				if stream.y > window.innerHeight
					stream.symbols = random_symbols()
					stream.speed = 3 + Math.random() * 5
					stream.y = - stream.symbols.length * 20
				for symbol in stream.symbols
					if Math.random() < 0.01
						symbol.v = random_katakana()

	<self>
		for stream in streams
			<stream x=stream.x y=stream.y symbols=stream.symbols>

	css
		height: 100vh
		width: 100vw
		overflow: hidden

imba.mount <app>
