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

import QtQuick 2.0
import "../mathUtils.js" as MathUtils

PopupBase {
    id: popover
    default property alias container: containerItem.data

    // theme
    property real edgeMargins: units.gu(2)
    property real callerMargins: units.gu(0.5)

    // private
    function updatePosition(item) {
        var pos = new PopupUtils.Positioning(item, popover, caller, edgeMargins, callerMargins);

        var minWidth = item.width + 2*edgeMargins;
        var minHeight = item.height + 2*edgeMargins;
        // TODO: do specialized positioning on small screens.

        var coords;
        if (!popover.caller) {
            // TODO: ERROR
            coords = pos.center();
        } else {
            coords = pos.auto();
        }

        item.x = coords.x;
        item.y = coords.y;
    }

    Background {
        dim: false
        ephemeral: true
    }

    Foreground {
        id: foreground
        width: Math.min(units.gu(40), popover.width)
        height: MathUtils.clamp(childrenRect.height, units.gu(40), 3*popover.height/4)

        // TODO: Make height of Foreground depend on containerItem height + margins?
        // TODO: make item after testing.
        Rectangle {
            id: containerItem
            color: "transparent"

            anchors {
                left: parent.left
                top: parent.top
                right: parent.right
                margins: units.gu(2)
            }

            height: childrenRect.height + anchors.margins //anchors.topMargin + anchors.bottomMargin
        }

        onWidthChanged: popover.updatePosition(foreground)
        onHeightChanged: popover.updatePosition(foreground)
    }

    onCallerChanged: updatePosition(foreground)
}
