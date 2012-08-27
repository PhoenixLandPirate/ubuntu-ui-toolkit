/*
 * Copyright 2012 Canonical Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 1.0
import Qt.labs.shaders 1.0

ShaderEffectItem {
    property variant mask
    property variant base
    property real gradientStrength: 1.0

    fragmentShader:
        "
        varying highp vec2 qt_TexCoord0;
        uniform lowp float qt_Opacity;
        uniform sampler2D mask;
        uniform sampler2D base;
        uniform lowp float gradientStrength;

        lowp vec3 blendOverlay(lowp vec3 base, lowp vec3 blend)
        {
            bvec3 comparison = lessThan(base, vec3(0.5));
            return mix(1.0 - 2.0 * (1.0 - base) * (1.0 - blend), 2.0 * base * blend, lowp vec3(comparison));
        }

        void main(void)
        {
            lowp vec4 maskColor = texture2D(mask, qt_TexCoord0.st);
            if (maskColor.a == 0.0) discard;

            lowp vec4 baseColor = texture2D(base, qt_TexCoord0.st);
            // this is equivalent to using a vertical linear gradient texture going from vec3(0.0) to vec3(1.0) with opacity 0.8
            lowp vec4 gradientColor = lowp vec4(qt_TexCoord0.ttt, 1.0) * 0.8;
            // FIXME: Because blendOverlay gives incorrect results when we use pre-multiplied alpha,
            // we remove the pre-multiplication before calling blendOverlay, and multiply again afterwards.
            // It works, but is not very elegant.
            lowp vec4 result = vec4(blendOverlay(baseColor.rgb/baseColor.a, gradientColor.rgb), 1.0);
            result *= qt_Opacity * baseColor.a;
            gl_FragColor = mix(baseColor, result, gradientStrength) * maskColor.a;
        }
        "
}