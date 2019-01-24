package graphics;

import kha.graphics4.TextureFormat;
import kha.math.FastMatrix2;
import kha.math.FastMatrix3;
import pongo.platform.display.Graphics.GPipeline;
import pongo.display.Texture;
import kha.Color;
import kha.Scheduler;
import kha.Scaler;
import kha.Image;
import kha.graphics4.ConstantLocation;
import kha.graphics4.IndexBuffer;
import pongo.display.FillSprite;
import pongo.Pongo;
import pongo.display.Pipeline;

import kha.math.FastVector4;

import kha.graphics4.IndexBuffer;
import kha.graphics4.PipelineState;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.Shaders;
import kha.graphics4.PipelineState;
import kha.graphics4.BlendingFactor;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.math.FastVector2;
import pongo.ecs.transform.Transform;
import pongo.display.Graphics;
import pongo.display.Sprite;

class StarSprite implements Sprite {

    static var TEXTURE_SIZE = 512;

    var iResolution : ConstantLocation;            // viewport resolution (in pixels)
    var iTime : ConstantLocation;                  // shader playback time (in seconds)
    var iDate : ConstantLocation;                  // (year, month, day, time in seconds)
    var iGlow  : ConstantLocation;                  // (year, month, day, time in seconds)
    
    var resolution : FastVector2;

    private var width : Float;
    private var height : Float;

    static var vb: VertexBuffer;
	static var ib: IndexBuffer;

    private var customPipeline :Pipeline;
    private var vertices : VertexBuffer;
    private var indices : IndexBuffer;

    private var texture : Texture;
    private var image : Image;
    private var glow : Float;

    private var pipeline : PipelineState;
    
    public function new(pongo :Pongo, glow : Float, width : Float, height : Float) : Void {
        this.width = width;
        this.height = height;
        this.glow = glow;
        initShader(pongo);
    }
    
    public function getNaturalWidth() : Float {
        return width;
    }
    public function getNaturalHeight() : Float {
        return height;
    }

    private function initShader(pongo : Pongo) {
        pipeline = new PipelineState();
        pipeline.vertexShader = Shaders.glowing_vert;
        pipeline.fragmentShader = Shaders.glowing_frag;

        var structure = new VertexStructure();
        structure.add("pos", VertexData.Float2);
        pipeline.inputLayout = [structure];
        pipeline.compile();

        var data = [-1.0, -1.0, 3.0, -1.0, -1.0, 3.0];
        var indices = [0, 1, 2];
        vb = new VertexBuffer(Std.int(data.length / (structure.byteSize() / 4)), structure, Usage.StaticUsage);
        var vertices = vb.lock();
        for (i in 0...vertices.length) vertices.set(i, data[i]);
        vb.unlock();

        ib = new IndexBuffer(indices.length, Usage.StaticUsage);
        var id = ib.lock();
        for (i in 0...id.length) id[i] = indices[i];
        ib.unlock();

        iResolution = pipeline.getConstantLocation("iResolution");
        iTime = pipeline.getConstantLocation("iTime");
        iGlow = pipeline.getConstantLocation("iGlow");


        resolution = new FastVector2(TEXTURE_SIZE, TEXTURE_SIZE);
        image = Image.createRenderTarget(TEXTURE_SIZE, TEXTURE_SIZE, TextureFormat.RGBA32, DepthAutoStencilAuto, 0);
        var g = image.g4;
        image.g2.begin();
        image.g2.fillRect(0,0, TEXTURE_SIZE, TEXTURE_SIZE);
        image.g2.end();
        g.begin();
        g.setPipeline(pipeline);
        g.setVector2(iResolution, resolution);
        g.setFloat(iTime, Scheduler.time());
        g.setFloat(iGlow, glow);
        g.setVertexBuffer(vb);
		g.setIndexBuffer(ib);
        g.drawIndexedVertices();
        g.end();

        texture = new pongo.platform.display.Texture(image);

        customPipeline = CUSTOM(pipeline, function(g) {
            // g.begin();
            
            image.g4.setPipeline(pipeline);
            image.g4.setVector2(iResolution, resolution);
            image.g4.setFloat(iTime, Scheduler.time());
            image.g4.setVertexBuffer(vb);
		    image.g4.setIndexBuffer(ib);
            image.g4.drawIndexedVertices();
            // g.end();
        });
    }

    public function draw(dt : Float, transform :Transform, graphics :Graphics) : Void
    {
        // graphics.setPipeline(customPipeline);
        graphics.drawScaledImage(texture, -width /2 , - height / 2, width, height);
        // graphics.setPipeline(DEFAULT);

    }

}